package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"slices"
	"strconv"
)

var regex = regexp.MustCompile("\\s+")
var day1input = "input"

func readLists() ([]int, []int, error) {
	f, err := os.OpenFile(day1input, os.O_RDONLY, os.ModePerm)
	if err != nil {
			log.Fatalf("open file error: %v", err)
			return nil, nil, err
	}
	defer f.Close()

	ll := make([]int, 0)
	lr := make([]int, 0)
	sc := bufio.NewScanner(f)
	for sc.Scan() {
		line := sc.Text()

		result := regex.Split(line, -1)
		if len(result) != 2 {
			log.Fatalf("invalid line: %s", line)
			return nil, nil, err
		}

		num1, _ := strconv.Atoi(result[0]);
		ll = append(ll, num1)
		
		num2, _ := strconv.Atoi(result[1])
		lr = append(lr, num2)
	}
	if err := sc.Err(); err != nil {
		log.Fatalf("scan file error: %v", err)
		return nil, nil, err
	}
	return ll, lr, nil
}

func computeDifference(ll []int, lr []int) int {
	slices.Sort(ll)
	slices.Sort(lr)

	sum := 0
	for i := 0; i < len(ll); i++ {
		left := ll[i]
		right := lr[i]
		diff := max(left, right) - min(left, right)
		sum += diff
	}
	return sum
}

func main() {
	ll, lr, err := readLists()
	if err != nil {
		log.Fatalf("readLists error: %v", err)
		return
	}
	fmt.Fprintf(os.Stdout, "Read %d and %d\n", len(ll), len(lr))
	fmt.Fprintf(os.Stdout, "Difference is %d\n", computeDifference(ll, lr))
}