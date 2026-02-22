# 📘 API Endpoints - Simple & Clean

## ✅ What Was Improved

### Before
```dart
// No URL encoding (unsafe with special characters)
static String itemById(String id) => '/items/$id';

// No organization
```

### After
```dart
// Safe URL encoding built-in
static String itemById(String id) => '/items/${_encode(id)}';

// Clean organization with comments
// Easy to read and maintain
```

---

## 📖 How to Use

### **Basic Usage**

```dart
import 'package:lost_n_found/core/api/api_endpoints.dart';

// Authentication
final loginUrl = ApiEndpoints.studentLogin;        // '/students/login'
final registerUrl = ApiEndpoints.studentRegister;  // '/students/register'

// Students
final studentsUrl = ApiEndpoints.students;              // '/students'
final studentUrl = ApiEndpoints.studentById('123');     // '/students/123'
final photoUrl = ApiEndpoints.studentPhoto('123');      // '/students/123/photo'

// Items
final itemsUrl = ApiEndpoints.items;                    // '/items'
final itemUrl = ApiEndpoints.itemById('abc');           // '/items/abc'
final claimUrl = ApiEndpoints.itemClaim('abc');         // '/items/abc/claim'

// Batches
final batchesUrl = ApiEndpoints.batches;                // '/batches'
final batchUrl = ApiEndpoints.batchById('2024');        // '/batches/2024'

// Categories
final categoriesUrl = ApiEndpoints.categories;          // '/categories'
final categoryUrl = ApiEndpoints.categoryById('tech');  // '/categories/tech'

// Comments
final commentsUrl = ApiEndpoints.comments;                    // '/comments'
final commentUrl = ApiEndpoints.commentById('c1');            // '/comments/c1'
final itemCommentsUrl = ApiEndpoints.commentsByItem('item1'); // '/comments/item/item1'
final likeUrl = ApiEndpoints.commentLike('c1');               // '/comments/c1/like'
```

### **Media URLs**

```dart
// Profile pictures
final profilePic = ApiEndpoints.studentProfilePicture('user.jpg');
// 'http://localhost:3000/profile_pictures/user.jpg'

// Item photos
final itemPhoto = ApiEndpoints.itemPicture('photo.jpg');
// 'http://localhost:3000/item_photos/photo.jpg'

// Item videos
final itemVideo = ApiEndpoints.itemVideo('video.mp4');
// 'http://localhost:3000/item_videos/video.mp4'
```

### **Search**

```dart
// Search items
final searchUrl = ApiEndpoints.itemSearch('wallet');
// '/items?q=wallet'
```

### **Base URLs**

```dart
// API base URL
final apiBase = ApiEndpoints.baseUrl;
// 'http://localhost:3000/api/v1'

// Media server URL
final mediaServer = ApiEndpoints.mediaServerUrl;
// 'http://localhost:3000'
```

---

## 🔧 Configuration

### **For Emulator (Default)**
```dart
static const bool isPhysicalDevice = false;
```

### **For Physical Device**
```dart
// 1. Set to true
static const bool isPhysicalDevice = true;

// 2. Update with your computer's IP
static const String _ipAddress = '192.168.1.100'; // Your IP here

// 3. Make sure your phone and computer are on same WiFi
```

### **Change Port**
```dart
static const int _port = 3000; // Change if needed
```

---

## ✨ Features

✅ **URL Encoding** - Safe handling of special characters
✅ **Platform Support** - iOS, Android, Web
✅ **Physical Device** - Easy testing on real devices
✅ **Clean Code** - Simple and readable
✅ **Type Safe** - Compile-time checking

---

## 🎯 Key Improvements

1. **URL Safety** - All IDs and filenames are URL-encoded
2. **Better Organization** - Clear sections with comments
3. **Simple to Use** - No complex structure
4. **Easy to Extend** - Add new endpoints easily

---

## 💡 Examples in Real Code

### **Login**
```dart
final response = await apiClient.post(
  ApiEndpoints.studentLogin,
  data: {'email': 'user@email.com', 'password': 'pass123'},
);
```

### **Get Item**
```dart
final response = await apiClient.get(
  ApiEndpoints.itemById('item-123'),
);
```

### **Upload Photo**
```dart
final formData = FormData.fromMap({'photo': file});
final response = await apiClient.post(
  ApiEndpoints.itemUploadPhoto,
  data: formData,
);
```

### **Search**
```dart
final response = await apiClient.get(
  ApiEndpoints.itemSearch('lost wallet'),
);
```

---

## 🚀 That's It!

Simple, clean, and professional! 🎉
