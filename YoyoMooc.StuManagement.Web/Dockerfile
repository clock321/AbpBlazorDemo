FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
RUN sed -i 's/TLSv1.2/TLSv1.0/g' /etc/ssl/openssl.cnf

ARG imageVersion=unkown
ENV image_version=$imageVersion
LABEL version=$imageVersion
RUN echo $imageVersion

WORKDIR /app

COPY . .

RUN chmod +x wait-for-it.sh
 
EXPOSE 80

# 测试 数据库连接的地址
ENV WAITHOST=HostName WAITPORT=1433

## 接口ok后再执行dotnet入口
ENTRYPOINT ["dotnet", "YoyoMooc.StuManagement.Web.dll"]