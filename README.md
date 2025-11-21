# Array Value Editor with Optional Prefix/Suffix

This server-side GTM variable transforms values inside an array of objects (e.g. GA4 `items`).  
You select which keys to modify and optionally apply a **prefix**, **suffix**, or full **replacement** using `{{value}}`.

- Works with **GA4 Ecommerce items** or a **custom array variable**.
- Applies transformations only to keys you define.
- Returns a new array with modified values.

---

## Examples

| Mode | Mapping Value | Original | Result |
|------|---------------|----------|--------|
| **Prefix only** | `abc_` | `123` | `abc_123` |
| **Suffix only** | `_eu` | `123` | `123_eu` |
| **Prefix + Suffix** | `x_` | `123` | `x_123x_` |
| **Replace (template)** | `SKU-{{value}}-EU` | `123` | `SKU-123-EU` |
| **Replace (no placeholder)** | `fixed_value` | `123` | `fixed_value` |

---

Useful for normalizing item IDs, categories, or other attributes before they are sent to downstream systems.
