import math
import os
import regex

const input_file = 'input'

// reads input file line-by-line, returns a list of levels
// where each level is a list []int{} of integers
fn read_file() ([][]int) {
  text := os.read_file(input_file) or { panic("failed to read the file: ${err}") }

  mut levels := [][]int{}

  // can't make re into a const because split mutates the receiver(?)
  mut re := regex.regex_opt('\\s') or { panic(err) }

  lines := text.split_into_lines()
  for line in lines {
    // split by whitespace
    segments := re.split(line)

    // build level (list of integers) from segments
    mut level := []int{}
    for _, num_str in segments {
      level << num_str.int()
    }
    levels << level
  }
  return levels
}

fn count_bad(level []int) int {
  // hack, use the first delta to determine what the sign for all deltas should be
  sign := level[1] - level[0]

  mut bad_count := 0
  for i, num in level {
    if i == 0 {
      continue
    }

    delta := num - level[i - 1]
    if delta == 0 // no change between levels 
        || math.abs(delta) > 3  // change of magnitude >3 is bad
        || math.copysign(delta, sign) != delta // delta's sign differs from the first delta's sign, that's bad (numbers changed direction)
    {
      bad_count += 1
    }
  }
  return bad_count
}

fn count_safe(levels [][]int, loose bool) int {
  mut safe_count := 0
  for _, level in levels {
    bad_levels := count_bad(level)
    if bad_levels == 0 || (loose && bad_levels == 1) {
      safe_count += 1
    }
  }
  return safe_count
}

fn main() {
  mut levels := read_file()

  safe_count := count_safe(levels, false)
  println('# of safe levels: ${safe_count}')

  safe_count_with_dampener := count_safe(levels, true)
  println('# of safe levels with dampener: ${safe_count_with_dampener}')
}