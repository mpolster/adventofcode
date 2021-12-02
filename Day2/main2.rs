use std::fs;

fn main() {
    let mut heigth = 0;
    let mut depth = 0;
    let mut aim = 0;

    let contents = fs::read_to_string("input.txt").expect("Error!");

    let split = contents.lines();
    let lines: Vec<&str> = split.collect();

    for line in lines {
        let k = line.split(" "); // Split single line by whitespace, get iterator k
        let vec: Vec<&str> = k.collect(); // collect items from iterator k in vector

        let x = vec[1].parse::<i32>().unwrap();
        if vec[0] == "forward" {
            heigth += x; // increase heigth by X
            depth += aim * x; // aim * X
        } else if vec[0] == "up" {
            aim -= x; // decrease depth by X
        } else if vec[0] == "down" {
            aim += x; // increase depth by X
        }
    }
    println!("heigth={}, depth={}, heigth*depth={}", heigth, depth, heigth*depth);
}
