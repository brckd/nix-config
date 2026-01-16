use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct Config {
    pub prefix: String,
    pub max_entries: usize,
    pub actions: Vec<Action>,
}

impl Default for Config {
    fn default() -> Self {
        Config {
            prefix: ":pw".to_string(),
            max_entries: 3,
            actions: vec![
                Action {
                    title: "Suspend".to_string(),
                    description: Some("Suspend the device".to_string()),
                    keywords: vec![
                        "suspend".to_string(),
                        "sleep".to_string(),
                        "stand by".to_string(),
                    ],
                    icon: Some("system-suspend".to_string()),
                    command: "systemctl".to_string(),
                    args: vec!["suspend".to_string()],
                    confirm: false,
                },
                Action {
                    title: "Restart".to_string(),
                    description: Some("Restart the device".to_string()),
                    keywords: vec!["restart".to_string(), "reboot".to_string()],
                    icon: Some("system-reboot".to_string()),
                    command: "systemctl".to_string(),
                    args: vec!["reboot".to_string()],
                    confirm: true,
                },
                Action {
                    title: "Power off".to_string(),
                    description: Some("Power off the device".to_string()),
                    keywords: vec![
                        "power off".to_string(),
                        "shut down".to_string(),
                        "turn off".to_string(),
                    ],
                    icon: Some("system-shutdown".to_string()),
                    command: "systemctl".to_string(),
                    args: vec!["poweroff".to_string()],
                    confirm: true,
                },
            ],
        }
    }
}

#[derive(Debug, Deserialize)]
pub struct Action {
    pub title: String,
    pub description: Option<String>,
    pub keywords: Vec<String>,
    pub icon: Option<String>,
    pub command: String,
    pub args: Vec<String>,
    pub confirm: bool,
}
