# Remove extra newlines:
[How to count delimiters and remove Line Feeds if not meet threshold](https://unix.stackexchange.com/questions/336308/how-to-count-delimiters-and-remove-line-feeds-if-not-meet-threshold)
Example: remove a file with 28 delimiters, where the delimiter is a pipe "|". Writing to the "output_file"
```bash
awk -F'|' '{while (NF < 29 && (getline nextline) > 0)
   $0 = $0 nextline; print}' < your-file > output_file
```


# Split and compress a large file

Splitting the file to 128MiB chunks, then compress each chunk with `gzip`
For Linux replace `gsplit` with `split`
For Mac the default `split` does not allow numerical suffixes. Use `brew` to install GNU `coreutils`, and use `gsplit` instead of `split`

```
gzip -c cleaned_vd_program_tags_qa.txt| gsplit -b 128MiB -d - video_descriptor_cleaned_full_dataset_06102021.gz_
```
