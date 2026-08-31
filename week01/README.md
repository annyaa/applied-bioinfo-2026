# README file for week 1

Hello World

**Let's get ready to analyze bioinformatics data!**

*For my AI-ready code editor, I have chosen VS code*

My version of *samtools* is **1.23.1**


## Commands and outputs shown below

### Commands needed to create a nested directory structure.

```bash
mkdir -p assignments/ex1/outputs
```

**Resulting Structure:**
```text
assignments/
└── ex1/
    └── outputs/
```


### Commands that create files in different directories

```bash
# Using full paths and the touch command
touch assignments/file1.txt assignments/ex1/file2.txt assignments/ex1/outputs/{file3.txt, file4.txt}
```

**Resulting Structure:**
```text
assignments/
├── file1.txt
└── ex1/
    ├── file2.txt
    └── outputs/
        ├── file3.txt
        └── file4.txt
```


### How to access these files using relative and absolute paths.

**Using Absolute Paths**

```bash
cat /Users/annsafo/edu/stats/applied-bioinfo-2026/week01/assignments/ex1/outputs/file4.txt
```

**Using Relative Paths**

```bash
# Option 1: Assuming I am currently inside the 'assignments' folder
cat ex1/outputs/file3.txt 

# Option 2: I am currently inside 'assignments/ex1/outputs/'
cat ../file2.txt

# Use '../..' to go up two levels to read file1.txt
cat ../../file1.txt
```
