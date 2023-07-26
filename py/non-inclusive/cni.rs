use std::collections::HashMap;
use std::env;
use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::Path;

fn load_inclusive_mapping(file: &File, delim: &str) -> HashMap<String, String> {
    let mut inclusive_mapping = HashMap::new();
    let reader = BufReader::new(file);

    for line in reader.lines() {
        if let Ok(line) = line {
            let parts: Vec<&str> = line.trim().split(delim).collect();
            if parts.len() == 2 {
                let non_inclusive = parts[0].trim().to_lowercase();
                let inclusive = parts[1].trim().to_string();
                inclusive_mapping.insert(non_inclusive, inclusive);
            }
        }
    }

    inclusive_mapping
}

fn replace_non_inclusive(document: &str, inclusive_mapping: &HashMap<String, String>) -> String {
    document
        .split_whitespace()
        .map(|word| {
            let lower_word = word.to_lowercase();
            if let Some(inclusive) = inclusive_mapping.get(&lower_word) {
                format!("[{}]", inclusive)
            } else {
                word.to_string()
            }
        })
        .collect::<Vec<String>>()
        .join(" ")
}

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<String> = env::args().collect();

    if args.len() < 4 {
        eprintln!("Usage: cargo run -- --noninclusive <non_inclusive_file> --doc <document_file> [--delim <delimiter>]");
        return Ok(());
    }

    let non_inclusive_path = &args[2];
    let document_path = &args[3];
    let delim = if args.len() >= 6 && args[4] == "--delim" {
        args[5].as_str()
    } else {
        ","
    };

    let non_inclusive_file = File::open(non_inclusive_path)?;
    let inclusive_mapping = load_inclusive_mapping(&non_inclusive_file, delim);

    let document_file = File::open(document_path)?;
    let document_reader = BufReader::new(document_file);
    let document: Vec<String> = document_reader.lines().collect::<Result<_, _>>()?;
    let document_str = document.join("\n");

    let replaced_document = replace_non_inclusive(&document_str, &inclusive_mapping);

    println!("Replaced document:");
    println!("{}", replaced_document);

    Ok(())
}

