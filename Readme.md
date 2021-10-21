
# module::NpmTools  [![status](https://github.com/Wandalen/wNpmTools/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wNpmTools/actions/workflows/StandardPublish.yml) [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)

Collection of tools to use npm programmatically.

### Try out from the repository

```
git clone https://github.com/Wandalen/wNpmTools
cd wNpmTools
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wnpmtools@stable'
```

`Willbe` is not required to use the module in your project as submodule.

### Examples

#### Fixate version of dependencies

File `package.json` ;

```json
{
  "dependencies" : {
    "wTools" : "",
    "wnpmtools" : ""
  }
}
```

Script `Script.s` :

```js
const _ = require( 'wnpmtools' );
_.npm.fileFixate
({
  localPath : __dirname,
  tag : 'stable',
});
```

Write both files in a directory. Run command `npm i` and then run `node Script.s`.

Check file `package.json` ( in Unix-like system run `cat package.json` ). File should look like.

```json
{
  "dependencies" : {
    "wTools" : "stable",
    "wnpmtools" : "stable"
  }
}
```

#### Logging of package versions

Printing of package tag versions.

File `package.json` ;

```json
{
  "name" : "wTools",
  "version" : "0.8.200",
  "dependencies" : {
    "wnpmtools" : ""
  }
}
```

Script `Script.s` :

```js
const _ = require( 'wnpmtools' );
_.npm.versionLog
({
  localPath : __dirname,
  remotePath : 'wTools',
  tags : [ 'stable', 'dev' ],
});
```

Write both files in a directory. Run command `npm i` and then run `node Script.s`. Output should look like :

```bash
Stable version of wTools : 0.8.1171
dev version of wTools : -no-
Current version : 0.8.200
```

