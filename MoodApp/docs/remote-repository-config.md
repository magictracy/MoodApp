# 远程仓库配置指南

## 已配置的远程仓库

### 1. Gitee（码云）- 主用仓库（推荐）
- **URL**: `https://gitee.com/qw2026/moodapp.git`
- **远程名称**: `gitee`
- **用途**: 日常开发使用，国内访问速度快且稳定

### 2. GitHub - 备用仓库
- **URL**: `https://github.com/magictracy/MoodApp.git`
- **远程名称**: `origin`
- **用途**: 国际同步和备份

## 常用命令

### 推送到 Gitee（推荐）
```bash
git push gitee master
```

### 推送到 GitHub
```bash
git push origin master
```

### 同时推送到两个仓库
```bash
git push gitee master
git push origin master
```

### 从 Gitee 拉取最新代码
```bash
git pull gitee master
```

### 查看远程仓库配置
```bash
git remote -v
```

## 认证方式

### Gitee 认证
首次推送时需要输入 Gitee 账号和密码：
- 用户名：您的 Gitee 用户名
- 密码：您的 Gitee 登录密码

### GitHub 认证
推荐使用以下方式之一：
1. **Personal Access Token (PAT)**
   - 在 GitHub Settings → Developer settings → Personal access tokens 生成
   - 使用 token 代替密码进行认证

2. **SSH 密钥**
   ```bash
   # 切换为 SSH 方式
   git remote set-url origin git@github.com:magictracy/MoodApp.git
   ```

3. **GitHub CLI**
   ```bash
   gh auth login
   ```

## 配置代理（可选）

如果访问 GitHub 不稳定，可以配置代理：

```bash
# 配置 HTTP 代理
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# 仅针对 GitHub 配置代理
git config --global http.https://github.com.proxy http://127.0.0.1:7890
git config --global https.https://github.com.proxy http://127.0.0.1:7890

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

## 最佳实践

1. **日常开发**: 使用 Gitee 作为主要远程仓库，推送速度快
2. **定期同步**: 每周或重要更新时同步到 GitHub
3. **分支策略**: 
   - `master/main`: 主分支，保持稳定
   - `develop`: 开发分支
   - `feature/*`: 功能分支

## 故障排查

### 推送失败：认证错误
- 检查用户名和密码是否正确
- Gitee 可能需要使用应用专用密码
- GitHub 建议使用 Personal Access Token

### 推送失败：网络超时
- 检查网络连接
- 尝试切换到 Gitee 仓库
- 配置代理后重试

### 冲突处理
```bash
# 先拉取最新代码
git pull gitee master

# 解决冲突后再次推送
git push gitee master
```

## 快速开始

```bash
# 1. 克隆仓库（从 Gitee）
git clone https://gitee.com/qw2026/moodapp.git

# 2. 添加 GitHub 远程仓库（可选）
git remote add origin https://github.com/magictracy/MoodApp.git

# 3. 日常开发流程
git add .
git commit -m "your commit message"
git push gitee master  # 推送到 Gitee
```

---

**最后更新**: 2026-05-16
