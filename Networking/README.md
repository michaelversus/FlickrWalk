# Networking

This is a mini networking library. It provides a struct `Resource`, which combines a URL request and a way to parse responses for that request. Because `Resource` is generic over the parse result, it provides a type-safe way to use HTTP endpoints.

## Example

This is a resource tha represents a user's data 

```swift
struct User: Codable {
    let name: String
    let info: String
}

func getUser(id: String) -> Resource<User> {
    return Resource(json: .get, url: URL(string: "https://someurl.com/users/\(id)")!)
}

let sampleResource = getUser(id: "1")
```

The code above is just a description of a resource, it does not load anything. `sampleResource` is a simple struct, which you can inspect and unit test. Here's how you can load a resource. The `result` is of type `Result<User, Error>`.

```swift
URLSession.shared.load(sampleResource) { result in 
    debugPrint(result)
}
```
