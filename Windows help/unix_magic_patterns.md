[How to count delimiters and remove Line Feeds if not meet threshold](https://unix.stackexchange.com/questions/336308/how-to-count-delimiters-and-remove-line-feeds-if-not-meet-threshold)
Example: remove a file with 28 delimiters, where the delimiter is a pipe "|". Writing to the "output_file"
```bash
awk -F'|' '{while (NF < 29 && (getline nextline) > 0)
   $0 = $0 nextline; print}' < your-file > output_file
```
