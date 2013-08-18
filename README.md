StringsSort
===========

Sorts a Localizable.strings file according to comment

Let’s say you have a `Localizable.strings` file you made with `genstrings` and it looks like this:

```
/* Super cool view controller */
"Awesome Title" = "Title!!";

/* Another super cool view controller */
"Really awesome title" = "¡Title!";

/* Super cool view controller */
"Button Title" = "Push Me";
```

Run `StringsSort` on that bad boy and you’ll get it *sorted*:

```
/* Another super cool view controller */
"Really awesome title" = "¡Title!";

/* Super cool view controller */
"Awesome Title" = "Title!!";
"Button Title" = "Push Me";
```

The individual strings are grouped according to the most recent comment, and the comment groups and strings are all sorted alphabetically.

**NOTE:** This is a super-simple one-off tool I made to scratch an itch. It’s rough. It relies on you calling it like this:

    StringsSort /path/to/input/file /path/to/output/file
    
It will use the same string encoding as the input file. There’s no manual, no usage info, nothing. Use at your own risk.
