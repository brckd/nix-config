pub mod config;

use abi_stable::{
    rvec,
    std_types::{
        ROption::{RNone, RSome},
        RString, RVec,
    },
};
use anyrun_plugin::{HandleResult, Match, PluginInfo, get_matches, handler, info, init};
use config::Config;
use fuzzy_matcher::{FuzzyMatcher, skim::SkimMatcherV2};
use std::{fs, process::Command};

#[derive(Debug)]
pub struct State {
    pub config: Config,
    pub mode: Mode,
}

#[derive(Debug)]
pub enum Mode {
    Err(String),
    Confirm(u64),
    List,
}

#[derive(Debug)]
pub enum Confirmation {
    Confirm,
    Cancel,
}

#[init]
fn init(config_dir: RString) -> State {
    let config = match fs::read_to_string(format!("{}/power.ron", config_dir)) {
        Ok(content) => ron::from_str(&content).unwrap_or_else(|why| {
            eprintln!("[power] Failed to parse config: {}", why);
            Config::default()
        }),

        Err(why) => {
            eprintln!("[power] No config file provided, using default: {}", why);
            Config::default()
        }
    };

    State {
        config,
        mode: Mode::List,
    }
}

#[info]
fn info() -> PluginInfo {
    PluginInfo {
        name: "Power".into(),
        icon: "system-shutdown".into(),
    }
}

fn get_error_matches(error_message: String) -> RVec<Match> {
    rvec![Match {
        title: "Error".into(),
        description: RSome(error_message.clone().into()),
        use_pango: false,
        icon: RSome("dialog-error".into()),
        id: RNone,
    }]
}

#[get_matches]
fn get_matches(input: RString, state: &State) -> RVec<Match> {
    match &state.mode {
        Mode::Err(error_message) => get_error_matches(error_message.clone()),
        Mode::Confirm(pending_action) => get_pending_matches(*pending_action, state),
        Mode::List => get_action_matches(input, state),
    }
}

fn get_pending_matches(pending_action: u64, state: &State) -> RVec<Match> {
    let action = &state.config.actions[pending_action as usize];

    rvec![
        Match {
            title: action.title.clone().into(),
            description: RSome("Proceed with this action".into()),
            use_pango: false,
            icon: RSome("go-next".into()),
            id: RSome(Confirmation::Confirm as u64)
        },
        Match {
            title: "Cancel".into(),
            description: RSome("Abort this action".into()),
            use_pango: false,
            icon: RSome("go-previous".into()),
            id: RSome(Confirmation::Cancel as u64)
        },
    ]
}

fn get_action_matches(input: RString, state: &State) -> RVec<Match> {
    let input = if let Some(input) = input.strip_prefix(&state.config.prefix) {
        input.trim()
    } else {
        return RVec::new();
    };

    let matcher = SkimMatcherV2::default().ignore_case();

    let entries = state.config.actions.iter().enumerate();
    let entries = entries.filter_map(|(id, action)| {
        let score = action
            .keywords
            .iter()
            .map(|keyword| matcher.fuzzy_match(keyword, input).unwrap_or(0))
            .max()
            .unwrap_or(0);

        if score > 0 {
            Some((id as u64, action, score))
        } else {
            None
        }
    });

    let mut entries: Vec<_> = entries.collect();
    entries.sort_by(|a, b| b.2.cmp(&a.2).then(a.1.title.cmp(&b.1.title)));
    entries.truncate(state.config.max_entries);

    let entries = entries.into_iter();
    let entries = entries.map(|(id, action, _)| Match {
        title: action.title.clone().into(),
        description: action.description.clone().map(Into::into).into(),
        use_pango: false,
        icon: action.icon.clone().map(Into::into).into(),
        id: RSome(id),
    });

    entries.collect()
}

#[handler]
fn handler(selection: Match, state: &mut State) -> HandleResult {
    let action = match state.mode {
        Mode::Err(_) => {
            return HandleResult::Close;
        }

        Mode::Confirm(pending_action) => {
            if selection.id.unwrap() == Confirmation::Cancel as u64 {
                state.mode = Mode::List;
                return HandleResult::Refresh(false);
            }

            &state.config.actions[pending_action as usize]
        }

        Mode::List => {
            let id = selection.id.unwrap();
            let action = &state.config.actions[id as usize];

            if action.confirm {
                state.mode = Mode::Confirm(id);
                return HandleResult::Refresh(true);
            }

            action
        }
    };

    let mut command = Command::new(action.command.clone());
    command.args(action.args.clone());
    let output = command.output();

    let error_message = match output {
        Err(err) => Some(err.to_string()),
        Ok(output) if !output.status.success() => {
            Some(String::from_utf8_lossy(&output.stderr).trim().to_string())
        }
        Ok(_) => None,
    };

    if let Some(error_message) = error_message {
        state.mode = Mode::Err(error_message);
        return HandleResult::Refresh(true);
    }

    HandleResult::Close
}
