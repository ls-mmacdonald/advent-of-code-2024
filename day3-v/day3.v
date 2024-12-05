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
		println('mul(${op1},${op2}) = ${op1 * op2}')

		index = match_end // advance
	}
	return sum
}


fn main() {
	text := read_file()
	sum := find_all_muls(text)
	println('Sum: ${sum}')
}