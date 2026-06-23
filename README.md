# svn_p

git clone一个大项目中的部分内容的时候比较麻烦，写个脚本打包起来，便于后面使用（svn已经不能用了，所以取名svn_p，p是plus）

## 安装

```bash
git clone git@github.com:yhbshishuaige/svn_p.git
chmod +x ./install.sh
./install.sh
```

## 用法

查看帮助

```bash
svn_p --help
```

```bash
svn_p <git-repo-url> <target-dir> --export=<subdir>
```

 - git-repo-url 项目地址
 - target-dir 目标目录
 - subdir 需要复制的子目录

## 原理

```bash
git clone --depth 1 --filter=blob:none --sparse git-repo-url "$tmp"
```
先clone到临时目录中

```bash
git -C "$tmp" --sparse-checkout set subdir
```
checkout指定目录到工作区

```bash
cp "$tmp"/subdir target-dir
```
复制到target目录

```bash
rm -rf "$tmp"
```
删除临时目录