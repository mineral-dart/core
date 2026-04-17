# Cache
The cache package provides a straightforward and effective solution for cache management in Mineral applications. By externalizing application consumption, it helps improve performance and optimize resources, thus offering a better user experience.

![icons technologies](https://skillicons.dev/icons?i=discord,dart,redis, )

## Introduction

Caching plays a crucial role in many applications by offering a temporary and decoupled storage solution from the core of the project. It helps optimize performance by reducing response times and limiting calls to external resources such as databases or APIs.

## Features
- **In-Memory Cache** : Stores data directly in memory, providing fast response times for accessing data already loaded into the cache.
- **Redis Cache** : Utilizes Redis as a caching storage system, enabling distributed caching and persistence of data across application restarts.
Installation

To use this package, simply add cache to your pubspec.yaml file:

```yaml
dependencies:
  mineral_cache: ^1.0.0
```
Then, run `dart pub get` to download and install the package.

## Usage

The cache can be used by importing the appropriate cache implementation, such as `memory provider` or `redis provider`. Detailed usage instructions can be found in the package documentation.
