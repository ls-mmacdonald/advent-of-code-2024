import math
import os
import regex

const input_file = 'input'
const line_regex = '\\s+'

// reads input file line-by-line, returns two lists of integers
fn read_file() ([]int, []int) {
  text := os.read_file(input_file) or { panic("failed to read the file: ${err}") }

  mut ll := []int{}
  mut lr := []int{}

  mut re := regex.regex_opt(line_regex) or { panic(err) }

  lines := text.split_into_lines()
  for line in lines {
    segments := re.split(line)
    if segments.len != 2 {
      eprintln('invalid line: ${line}')
      continue
    }

    ll << segments[0].int()
    lr << segments[1].int()
  }
  return ll, lr
}

// diff is the sum of absolute differences between corresponding elements of l and r
fn compute_diff(l []int, r []int) int {
  mut diff := 0
  for i, _ in l {
    diff += math.max(l[i], r[i]) - math.min(l[i], r[i])
  }
  return diff
}

// similarity score is sum of: each number in l, multipled by the count of its occurrences in r
fn calc_similarity(l []int, r []int) int {
  mut r_freqs := map[int]int{}
  for _, v in r {
    r_freqs[v] += 1 // zero value of 0 is returned if key is not present?
  }

  mut similarity := 0
  for _, left_value in l {
    right_freq := r_freqs[left_value]
    similarity += left_value * right_freq
  }
  return similarity
}

fn main() {
  mut ll, mut lr := read_file()
  println('read left ${ll.len}, right ${lr.len} elements')

  if ll.len != lr.len {
    panic('lists have different lengths 😱😱')
  }

  // sort (this mutates the lists)
  ll.sort()
  lr.sort()

  diff := compute_diff(ll, lr)
  println('diff: ${diff}')

  similarity := calc_similarity(ll, lr)
  println('similarity: ${similarity}')
}