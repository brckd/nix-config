pub mod config;

use std::{collections::HashMap, process::Command, fs};
use abi_stable::std_types::{ROption, RString, RVec};
use anyrun_plugin::{HandleResult, Match, PluginInfo, get_matches, handler, info, init};
use fuzzy_matcher::{FuzzyMatcher, skim::SkimMatcherV2};
use config::{Config, Action};

#[derive(Debug)]
pub struct State {
    pub actions: HashMap<u64, Action>,
}

#[init]
fn init(config_dir: RString) -> State {
    let config = match fs::read_to_string(format!("{}/power.ron", config_dir)) {
        Ok(content) => ron::from_str(&content).unwrap_or_else(|why| {
            eprintln!("[nix-run] Failed to parse config: {}", why);
            Config::default()
        }),
        Err(why) => {
            eprintln!("[nix-run] No config file provided, using default: {}", why);
            Config::default()
        }
    };

    let actions = config.actions
        .into_iter()
        .enumerate()
        .map(|(id, action)| (id as u64, action))
        .collect();

    State { actions }
}

#[info]
fn info() -> PluginInfo {
    PluginInfo {
        name: "Power".into(),
        icon: "system-shutdown".into(),
    }
}

#[get_matches]
fn get_matches(input: RString, state: &State) -> RVec<Match> {
    let matcher = SkimMatcherV2::default().ignore_case();

    let mut entries: Vec<_> = state
        .actions
        .iter()
        .filter_map(|(id, action)| {
            let score = action
                .keywords
                .iter()
                .map(|keyword| matcher.fuzzy_match(keyword, &input).unwrap_or(0))
                .max()
                .unwrap_or(0);

            if score > 0 {
                Some((*id, action, score))
            } else {
                None
            }
        })
        .collect();

    entries.sort_by(|a, b| b.2.cmp(&a.2).then(a.1.title.cmp(&b.1.title)));

    entries
        .into_iter()
        .map(|(id, action, _)| Match {
            title: action.title.clone().into(),
            description: action.description.clone().map(Into::into).into(),
            use_pango: false,
            icon: action.icon.clone().map(Into::into).into(),
            id: ROption::RSome(id),
        })
        .collect()
}

#[handler]
fn handler(selection: Match, state: &State) -> HandleResult {
    let action = state.actions.get(&selection.id.unwrap()).unwrap();

    let mut command = Command::new(action.command.clone());
    command.args(action.args.clone());

    #[expect(clippy::zombie_processes, reason = "this command should not be waited for")]
    command.spawn().unwrap();

    HandleResult::Close
}
