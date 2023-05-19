%dw 2.0
import * from dw::util::Tree
import * from dw::core::Arrays
import * from dw::core::Objects

// Recursive parse Object and returns the Object with flattend key
// Note:
//  - This function does not parse items inside an array.

fun tree_seq (obj: Object) = do {
    fun flatten_tree (m, rest,  r, path) = do {
            var x = (entrySet (m) [0])
            ---
            if (isEmpty(m) and isEmpty(rest))
               r
           else if (isEmpty(m))
               flatten_tree (rest [-1].v, take(rest, (sizeOf(rest) - 1)), r, rest [-1].p)
           else if (x.value is Object)
               flatten_tree (x.value,
                             (rest << {v: (m - x.key),  p: path}) filter ((z) -> (not isEmpty (z.v))),
                             r,
                             path << x.key)
           else
               flatten_tree ({},
                             (rest << {v: (m - x.key), p: path}) filter ((z) -> (not isEmpty (z.v))),
                             r << {((path << x.key) joinBy (".")): x.value},
                             path)
        }

        ---
        flatten_tree (obj, [],  [], []) reduce ((item, acc={}) ->acc ++ item)
}

output json
---
tree_seq(payload)


// INPUT: 
// {"a": 10, "b": {"g": 30},  "c": {"d": {"f": {"x": "22"}}, "e": {"f": 90, "h":100, "x":200, "xz":[{"a": 400}], "ppp":30}}}

// OUTPUT:
// {
//   "a": 10,
//   "b.g": 30,
//   "c.d.f.x": "22",
//   "c.e.f": 90,
//   "c.e.h": 100,
//   "c.e.x": 200,
//   "c.e.xz": [
//     {
//       "a": 400
//     }
//   ],
//   "c.e.ppp": 30
// }



