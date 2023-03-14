class Solution {
  final Map<String, int> encode = {
    "I": 1,
    "V": 5,
    "X": 10,
    "L": 50,
    "C": 100,
    "D": 500,
    "M": 1000,
  };

  final Map<String, List<String>> subtractMap = {
    "I": ["V", "X"],
    "X": ["L", "C"],
    "C": ["D", "M"],
  };

  int romanToInt(String s) {
    if (s.isEmpty) return 0;

    if (s.length == 1) {
      return encode[s] ?? 0;
    }

    int result = 0;
    List<String> extractString = s.split("");

    String previous = extractString.first;

    for (int index = 1; index < extractString.length; index++) {
      String element = extractString.elementAt(index);

      if (encode[element]! <= encode[previous]!) {
        result += encode[previous]!;
        previous = element;
      } else {
        result += encode[element]! - encode[previous]!;
        index += 2;
        if (index >= extractString.length) {
          break;
        }
        previous = extractString.elementAt(index);
      }
    }
    return result;
  }
}

void main() {
  print(Solution().romanToInt("III"));
}

// Input: s = "III"
// Output: 3
// Explanation: III = 3.
// Example 2:

// Input: s = "LVIII"
// Output: 58
// Explanation: L = 50, V= 5, III = 3.
// Example 3:

// Input: s = "MCMXCIV"
// Output: 1994
// Explanation: M = 1000, CM = 900, XC = 90 and IV = 4.

// 49 =
// XLIX