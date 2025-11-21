# sgtm-array-value-editor-with-prefix-suffix

# Array Value Editor with Optional Prefix/Suffix

This server-side GTM variable modifies values inside an array of objects (such as GA4 `items`).  
You define which keys to transform and provide a new value to apply.

- Supports **GA4 items** or a **custom array variable**.
- For each selected key, you can:
  - **Add a prefix**
  - **Add a suffix**
  - **Or fully replace the value** using a template like `SKU-{{value}}`.
- Returns a new transformed array while keeping all other values intact.

Useful for standardizing item IDs, categories, or other item attributes before sending them to downstream platforms.

