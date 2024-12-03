package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
)

var lineRegex = regexp.MustCompile("\\s+")
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

		result := lineRegex.Split(line, -1)
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

func getFrequencyMap(l []int) map[int]int {
	freqs := make(map[int]int)
	
	for _, num := range l {
		if _, ok := freqs[num]; ok {
			freqs[num]++
		} else {
			freqs[num] = 1
		}
	}
	return freqs
}

func calcSimilarity(ll []int, lr []int) int {
	// This map stores the # of times each number in lr occurs in lr
	frequencies := getFrequencyMap(lr)

	similarity := 0
	for _, num := range ll {
		// Similarity score is the number times the count of its occurrences in lr
		freq := frequencies[num]	
		similarity += num * freq
	}
	return similarity
}

func main() {
	ll, lr, err := readLists()
	if err != nil {
		log.Fatalf("readLists error: %v", err)
		return
	}
	fmt.Fprintf(os.Stdout, "Left list size: %d, right list size: %d\n", len(ll), len(lr))
	fmt.Fprintf(os.Stdout, "Similarity score is %d\n", calcSimilarity(ll, lr))
}