# dupit.sh
My attempt at a basic shell script wrapper for the venerable [duplicity](http://duplicity.nongnu.org/) backup utility.

**Why another duplicity wrapper?**

- duplicity is extremely flexible and feature rich, but that flexibility and feature set can make it difficult to automate the backups in a consistent way across machines
- duplicity relies upon several 'secrets' such as GnuPGP (gpg) to encrypt the backups, storage-backend keys and credentials. While these can be written into a quick-n-dirty shell script or cron job and exported as ENV vars, I want a way to separate the functionality from the configuration values so that the script remains as portable as possible.
- [NIH Syndrome](https://en.wikipedia.org/wiki/Not_invented_here). While I normally try to stand on the shoulders of giants, the other wrappers that I looked at either didn't do what I needed, or were overly complex, nor were any of them something that I felt I could contribute via PR, etc.
- Practice

### License
dupit.sh is licensed under the [BSD 2-Clause License](https://opensource.org/licenses/BSD-2-Clause)