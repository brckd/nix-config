use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct Config {
    pub actions: Vec<Action>,
}

impl Default for Config {
    fn default() -> Self {
        Config {
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
                },
                Action {
                    title: "Restart".to_string(),
                    description: Some("Restart the device".to_string()),
                    keywords: vec!["restart".to_string(), "reboot".to_string()],
                    icon: Some("system-reboot".to_string()),
                    command: "systemctl".to_string(),
                    args: vec!["reboot".to_string()],
                },
                Action {
                    title: "Restart to UEFI".to_string(),
                    description: Some("Restart and enter the UEFI".to_string()),
                    keywords: vec![
                        "restart to".to_string(),
                        "reboot to".to_string(),
                        "uefi".to_string(),
                        "bios".to_string(),
                        "firmware setup".to_string(),
                    ],
                    icon: Some("preferences-system".to_string()),
                    command: "systemctl".to_string(),
                    args: vec!["reboot".to_string(), "--firmware-setup".to_string()],
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
                },
                Action {
                    title: "Log out".to_string(),
                    description: Some("Log out of this session".to_string()),
                    keywords: vec!["log out".to_string()],
                    icon: Some("system-log-out".to_string()),
                    command: "uwsm".to_string(),
                    args: vec!["stop".to_string()],
                },
                Action {
                    title: "Lock screen".to_string(),
                    description: Some("Lock the screen".to_string()),
                    keywords: vec!["lock screen".to_string()],
                    icon: Some("system-lock-screen".to_string()),
                    command: "hyprlock".to_string(),
                    args: vec![],
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
}

