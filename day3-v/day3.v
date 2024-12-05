import os
import regex

const input_file = 'input'

// read file as string
fn read_file() string {
  return os.read_file(input_file) or { panic("failed to read the file: ${err}") }
}

fn find_all_muls(text string) int {
	// regex objects are mutable and all the methods mutate them (eg find_from)
  mut mul_re := regex.regex_opt('mul\\((?P<op1>\\d{1,3}),(?P<op2>\\d{1,3})\\)') or { panic(err) }

	mut index := 0
	mut sum := 0
	for i := 0; index < text.len; i++ {
		// Find the next instance of mul(xxx,yyy) in the text
		match_start, match_end := mul_re.find_from(text, index)
		if match_start == -1 {
			println('no more matches at ${index}')
			break
		}
		// println('found mul at ${match_start}-${match_end}')

		// read xxx
		mut start, mut end := mul_re.get_group_bounds_by_name('op1')
		op1 := text[start..end].int()

		// read yyy
		start, end = mul_re.get_group_bounds_by_name('op2')
		op2 := text[start..end].int()

		sum += op1 * op2
		index = match_end // advance
	}
	return sum
}

fn find_all_muls2(text string) int {
  mut mul_re := regex.regex_opt('(do\\(\\))|(don\'t\\(\\))|(mul\\((?P<op1>\\d{1,3}),(?P<op2>\\d{1,3})\\))') or { panic(err) }
	
	mut enabled := true
	mut index := 0
	mut sum := 0
	for i := 0; index < text.len; i++ {
		// Find the next instance of do() or don't() or mul(xxx,yyy) in the text
		match_start, match_end := mul_re.find_from(text, index)
		if match_start == -1 {
			println('no more matches at ${index}')
			break
		}
		
		instance := text[match_start..match_end]
		match instance {
			'do()' {
				enabled = true
				// println('ON at ${match_start}-${match_end} (${instance})')
			}
			'don\'t()' {
				enabled = false
				// println('OFF at ${match_start}-${match_end} (${instance})')
			}
			else {
				if enabled {
					// read xxx of mul(xxx,yyy)
					mut start, mut end := mul_re.get_group_bounds_by_name('op1')
					op1 := text[start..end].int()

					// read yyy of mul(xxx,yyy)
					start, end = mul_re.get_group_bounds_by_name('op2')
					op2 := text[start..end].int()

					sum += op1 * op2
				}
			}
		}

		index = match_end // advance
	}
	return sum
}

fn main() {
	text := read_file()

	// part 1
	sum := find_all_muls(text)
	println('Part 1 answer: ${sum}')

	println('------------------------------------------')

	// part 2
	sum2 := find_all_muls2(text)
	println('Part 2 answer: ${sum2}')
}