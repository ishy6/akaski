# --- 第一阶段：构建阶段 (Build Stage) ---
# 1. 使用 Node 镜像作为基础
FROM node:latest AS build-stage

# 2. 设置容器内的工作目录
WORKDIR /app

# 3. 先拷贝 package.json 和 lock 文件（利用 Docker 缓存机制加速构建）
COPY package*.json ./

# 4. 安装项目依赖
RUN npm install

# 5. 拷贝项目所有源码到容器
COPY . .

# 6. 执行 Vue 打包命令，生成 dist 文件夹
RUN npm run build


# --- 第二阶段：生产阶段 (Production Stage) ---
# 7. 使用 Nginx 镜像
FROM nginx:latest AS production-stage

# 8. 从第一阶段(build-stage)拷贝打包好的产物到 Nginx 目录
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 9. 暴露 80 端口并启动 Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]