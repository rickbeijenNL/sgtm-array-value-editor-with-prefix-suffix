___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Array Value Editor with Optional Prefix/Suffix",
  "description": "Optionally add a prefix or suffix to array values. When enabled, the transform value wraps the original. If both are off, the original value is fully replaced.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "itemsArraySource",
    "displayName": "Array Source (Array of Object)",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "useGa4Source",
        "displayValue": "Use GA4 Ecommerce Items Array"
      },
      {
        "value": "useCustomSource",
        "displayValue": "Use Custom Variable"
      }
    ],
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "inputArrayVar",
    "displayName": "Items Array Variable",
    "simpleValueType": true,
    "help": "Enter the variable that contains the array of items you want to transform.",
    "valueHint": "Example: {{dlv - ecommerce.items}}",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "itemsArraySource",
        "paramValue": "useCustomSource",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "attrArrayTransformation",
    "displayName": "Key Value Mapping",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Transform Key",
        "name": "transformKey",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "New Value",
        "name": "transformValue",
        "type": "TEXT"
      }
    ],
    "newRowButtonText": "Add Mapping",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "enablePrefix",
    "checkboxText": "Add values as prefix",
    "simpleValueType": true,
    "help": "Tick this box if the value should be added as a prefix. For example when filling in \u0027abc_\u0027 for the item_id, the item_id of 123 will be transformed to \u0027abc_123\u0027"
  },
  {
    "type": "CHECKBOX",
    "name": "enableSuffix",
    "checkboxText": "Add values as suffix",
    "simpleValueType": true,
    "help": "Tick this box if the value should be added as a suffix. For example when filling in \u0027_abc\u0027 for the item_id, the item_id of 123 will be transformed to \u0027123_abc\u0027"
  }
]


___SANDBOXED_JS_FOR_SERVER___

const getType = require('getType');
const getEventData = require('getEventData');
const makeTableMap = require('makeTableMap');
const makeString = require('makeString');

// ------------------------------
// 1. Determine the source of items
// ------------------------------
let items;

if (data.itemsArraySource === 'useGa4Source') {
  items = getEventData('items');
} else {
  items = data.inputArrayVar;
}

if (getType(items) !== 'array') {
  return undefined;
}

// ------------------------------
// 2. Load transformation table
// ------------------------------
//
// attrArrayTransformation must contain:
// - transformKey     = the key to modify
// - transformValue   = the value to use as prefix/suffix or template
//
const transformations = makeTableMap(
  data.attrArrayTransformation,
  'transformKey',
  'transformValue'
);

// If nothing configured, return original items
if (!transformations || getType(transformations) !== 'object') {
  return items;
}

// ------------------------------
// 2b. Read prefix/suffix options
// ------------------------------
var enablePrefix = data.enablePrefix === true;
var enableSuffix = data.enableSuffix === true;

// ------------------------------
// 3. Transform each item
// ------------------------------
const transformedItems = items.map(function (item) {

  // Ensure item is an object
  if (getType(item) !== 'object' || !item) {
    return item;
  }

  const newItem = {};

  // Copy original item
  for (var key in item) {
    if (!item.hasOwnProperty(key)) continue;

    let value = item[key];

    // If this key has a transformation configured
    if (transformations[key] !== undefined) {
      var mappingValue = makeString(transformations[key]);
      var originalStr  = makeString(value);

      if (enablePrefix || enableSuffix) {
        // Prefix/suffix mode
        var newVal = originalStr;

        if (enablePrefix) {
          newVal = mappingValue + newVal;
        }
        if (enableSuffix) {
          newVal = newVal + mappingValue;
        }

        value = newVal;
      } else {
        // Legacy / template mode: support {{value}} placeholder
        value = mappingValue.replace('{{value}}', originalStr);
      }
    }

    newItem[key] = value;
  }

  return newItem;
});

// ------------------------------
// 4. Return transformed array
// ------------------------------
return transformedItems;


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 2/24/2025, 4:59:33 PM


