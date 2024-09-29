use std::env;
use std::io::{
    stdin,
    stdout,
    Write,
};

fn main() {
    let args = env::args();
    let args = args.collect::<Vec<String>>();
    let prompt = args.get(1).and_then(|s| Some(format!("{} ", s)));

    print!("{}[Y/N]: ", prompt.unwrap_or(String::from("")));
    stdout().flush().expect("failed to flush stdout");

    let mut s = String::new();
    stdin().read_line(&mut s).expect("read_line error");

    if !s.starts_with('y') && !s.starts_with('Y') {
        std::process::exit(1);
    }

    std::process::exit(0);
}
