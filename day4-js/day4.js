const { readFileSync } = require("node:fs");

const file = readFileSync("./input", "utf-8");

// matrix[][] is a 2d array of characters
const matrix = file.split(/\n/).map((line) => line.split(""));

// can overlap - eg XMASAMX and SAMXMAS should each count as 2
// so use lookahead to allow us to match the same char twice
const regex = /XMA(?=S)|SAM(?=X)/g;

function findHorizontals(input = matrix) {
  let count = 0;
  for (const row of input) {
    const str = row.join("");
    while (regex.exec(str)) {
      count++;
    }
  }

  return count;
}

// copilot wrote this
function transpose(input) {
  return input[0].map((_, i) => input.map((row) => row[i]));
}

function findVerticals() {
  // flip the matrix 90 degrees and re-use findHorizontals
  const transposed = transpose(matrix);
  return findHorizontals(transposed);
}

function findDiagonals() {
  let count = 0;

  const at = getCoords.bind(null, matrix);

  for (let i = 0; i < matrix.length; i++) {
    const row = matrix[i];
    for (let j = 0; j < row.length; j++) {
      const cell = row[j];
      if (cell !== "X") {
        continue;
      }
      // check for MAS in adjacent positions around X:
      //  M M
      //   X
      //  M M
      if ("M" === at(i - 1, j - 1)) {
        // M at top left
        if ("A" === at(i - 2, j - 2) && "S" === at(i - 3, j - 3)) {
          // console.log("Found XMAS to top left at (%d,%d)", i, j);
          count++;
        }
      }
      if ("M" === at(i + 1, j - 1)) {
        // M at top right
        if ("A" === at(i + 2, j - 2) && "S" === at(i + 3, j - 3)) {
          // console.log("Found XMAS to top right at (%d,%d)", i, j);
          count++;
        }
      }
      if ("M" === at(i + 1, j + 1)) {
        // M at bottom right
        if ("A" === at(i + 2, j + 2) && "S" === at(i + 3, j + 3)) {
          // console.log("Found XMAS to bottom right at (%d,%d)", i, j);
          count++;
        }
      }
      if ("M" === at(i - 1, j + 1)) {
        // M at bottom left
        if ("A" === at(i - 2, j + 2) && "S" === at(i - 3, j + 3)) {
          // console.log("Found XMAS to bottom left at (%d,%d)", i, j);
          count++;
        }
      }
    }
  }
  return count;
}

// finds the count of X-shaped MAS occurrences
function findXmasCount() {
  const at = getCoords.bind(null, matrix);

  let count = 0;
  for (let i = 0; i < matrix.length; i++) {
    const row = matrix[i];
    for (let j = 0; j < row.length; j++) {
      const cell = row[j];
      // Start by finding A's
      if (cell !== "A") {
        continue;
      }

      // We have an 'A', now look for each arm of the 'X' shape. Start with the \ arm
      //
      // S        M
      //  A   or   A
      //   M        S
      const tl = at(i-1, j-1);
      const br = at(i+1, j+1);
      if ((tl === 'S' && br === 'M') || (tl === 'M' && br === 'S')) {
        // Now check for the / arm
        //
        //   S        M
        //  A   or   A
        // M        S
        const tr = at(i+1, j-1);
        const bl = at(i-1, j+1);
        if ((tr === 'S' && bl === 'M') || (tr === 'M' && bl === 'S')) {
          // console.log("Found X-MAS centered at (%d,%d)", i, j);
          count++;
        }
      }
    }
  }
  return count;
}

function getCoords(matrix, i, j) {
  return matrix[i]?.[j] ?? undefined;
}

function part1() {
  const horizCount = findHorizontals();
  console.log("  Found %d horizontals", horizCount);

  const vertCount = findVerticals();
  console.log("  Found %d verticals", vertCount);

  const diagCount = findDiagonals();
  console.log("  Found %d diagonals", diagCount);

  const total = vertCount + horizCount + diagCount;
  console.log("Total XMAS: %d", total);
}

function part2() {
  const x_masCount = findXmasCount();
  console.log("Total X-MAS: %d", x_masCount);
}

function main() {
  part1();
  part2();
}

main();