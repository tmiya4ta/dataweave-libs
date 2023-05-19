%dw 2.0
import * from dw::util::Tree
import * from dw::core::Arrays
import * from dw::core::Objects

fun tree_seq_easy (obj) = do {
    fun flatten_tree (m, r, path) = (if (m is Object)
                                     flatten (m pluck((v, k) ->
                                                 if (v is Object)
                                                     flatten_tree (v, r, path << k)
                                                 else
                                                     flatten_tree (v, r << {((path << k) joinBy (".")): v}, path)))
                                else r)
        ---
        flatten_tree (obj, [], []) reduce ((item, acc={}) ->acc ++ item)
}

output json
---
tree_seq_easy(payload)
