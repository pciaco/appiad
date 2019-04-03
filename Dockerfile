FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["appiad/appiad.csproj", "appiad/"]
RUN dotnet restore "appiad/appiad.csproj"
COPY . .
WORKDIR "/src/appiad"
RUN dotnet build "appiad.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "appiad.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
CMD ASPNETCORE_URLS=http://*:$PORT dotnet appiad.dll