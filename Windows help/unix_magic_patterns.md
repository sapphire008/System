# Remove extra newlines:
[How to count delimiters and remove Line Feeds if not meet threshold](https://unix.stackexchange.com/questions/336308/how-to-count-delimiters-and-remove-line-feeds-if-not-meet-threshold)
Example: remove a file with 28 delimiters, where the delimiter is a pipe "|". Writing to the "output_file"
```bash
awk -F'|' '{while (NF < 29 && (getline nextline) > 0)
   $0 = $0 nextline; print}' < your-file > output_file
```

Delimit by double pipes `||` and matching patterns such that the last cell is not empty

awk -F'[|][|]' '{while ( (NF < 8 || $8 !~ /[A-Za-z0-9]+/) && (getline nextline) > 0 )
   $0 = $0 nextline; print}' < vd_program_tags_qa.txt > cleaned_vd_program_tags_qa.txt

# Replace any tab character with space
```bash
tr \\t ' ' < cleaned_vd_program_tags_qa.txt > no-tab-vd_program_tags_qa.txt
```

# Replace all the double pipes as tab, turning into tsv file.
```bash
awk -F"[|][|]" -v OFS="\t" ' $1=$1 ' no-tab-vd_program_tags_qa.txt > tab_delimited_vd_program_tags_qa.tsv
```

# Split and compress a large file

Splitting the file to 128MiB chunks, then compress each chunk with `gzip`

For Linux replace `gsplit` with `split`

For Mac the default `split` does not allow numerical suffixes. Use `brew` to install GNU `coreutils`, and use `gsplit` instead of `split`

```bash
gzip -c cleaned_vd_program_tags_qa.txt | gsplit -b 128MiB -d - video_descriptor_cleaned_full_dataset_06102021.gz_
```
