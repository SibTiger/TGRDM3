Designed for Notepad++<br>
Base theme: Deep Black

To install: Text Version 2
 1. Open Notepad++
 2. Language Menu
 3. Define your language
 4. Import
 5. Select the file: 'txt2.xml'


# Difference between regular Text and Text2
## Folding
Supports folding using:

| Opening | Middle | Closing |
|---------|--------|---------|
| #if     | #elseif| #endif  |
| #region |        |#endregion|
| /*      |        | */      |
| //      |        |         |
| {       |        | }       |

## Highlights

### Keywords
| Keyword | Colour | Other Attributes | Cap Sensitive| Description |
|---------|--------|------------------|--------------|-------------|
| TODO    | Red    | Underline        | Yes          | Personal Reminder|
| FIX     | Red    | Underline        | Yes          | Personal Reminder|
| LOOK    | Red    | Underline        | Yes          | Personal Reminder|

Example of usage:<br>
  `// FIX: Dividing by zero causes unforeseen consequences.  We should probably fix that....`

### Numbers
When using numbers with or without decimals, they will automatically change colours to distinguish them from the rest of the text.

Example of usage:<br>
  `DynamicVoid_DeepAxisLogic = 500;`<br>
  `DynamicVoid_DeepAxisMultiplier = 1.2;`
