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

fn is_safe(level []int) bool {
  // hack, use the first delta to determine what the sign for all deltas should be
  sign := level[1] - level[0]

  for i, num in level {
    if i == 0 {
      continue
    }

    delta := num - level[i - 1]
    if delta == 0 || math.abs(delta) > 3 {
      // magnitude of difference is zero or is too great
      return false
    }

    // if sign of any delta differs from sign of the first delta, that's also a no-no
    // since it means the numbers changed direction
    if math.copysign(delta, sign) != delta {
      return false
    }
  }
  return true
}

fn main() {
  mut levels := read_file()

  mut safe_count := 0
  for _, level in levels {
    if is_safe(level) {
      safe_count += 1
    }
  }

  println('# of safe levels: ${safe_count}')
}