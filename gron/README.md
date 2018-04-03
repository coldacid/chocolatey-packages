# gron

Make JSON greppable!

gron transforms JSON into discrete assignments to make it easier to `grep` for what you want and see the absolute 'path' to it.
It eases the exploration of APIs that return large blobs of JSON but have terrible documentation.

```
▶ gron "https://api.github.com/repos/tomnomnom/gron/commits?per_page=1" | fgrep "commit.author"
json[0].commit.author = {};
json[0].commit.author.date = "2016-07-02T10:51:21Z";
json[0].commit.author.email = "mail@tomnomnom.com";
json[0].commit.author.name = "Tom Hudson";
```

gron can work backwards too, enabling you to turn your filtered data back into JSON:
```
▶ gron "https://api.github.com/repos/tomnomnom/gron/commits?per_page=1" | fgrep "commit.author" | gron --ungron
[
  {
    "commit": {
      "author": {
        "date": "2016-07-02T10:51:21Z",
        "email": "mail@tomnomnom.com",
        "name": "Tom Hudson"
      }
    }
  }
]
```

> Disclaimer: the GitHub API has fantastic documentation, but it makes for a good example.
