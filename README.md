# Identicon

## What is Identicon?
* This is image which we can get from user`s hash;
* Identicon should be 5x5 blocks, each block is 5x5 pixel;  

## Algorithm
* User input to MD5 hash;
* Get RGB color from MD5 hash (it will be first three elements of the list);
* Create indexed list of 15 elements;
* Generate image from list;
