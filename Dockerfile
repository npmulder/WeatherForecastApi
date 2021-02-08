FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["src/WeatherForcast.Api/WeatherForcast.Api.csproj", "WeatherForcast.Api/"]

RUN dotnet restore "WeatherForcast.Api/WeatherForcast.Api.csproj"
COPY src/ .
WORKDIR "/src/WeatherForcast.Api"
RUN dotnet build "WeatherForcast.Api.csproj" -c Release -o /app/build 

FROM build AS publish
RUN dotnet publish "WeatherForcast.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WeatherForcast.Api.dll"]