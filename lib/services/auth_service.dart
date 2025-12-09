import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _currentUser;

  // Initialize dummy users in Firestore
  Future<void> initializeUsers() async {
    try {
      // Check if users collection is empty
      final usersSnapshot = await _firestore.collection('users').limit(1).get();
      
      if (usersSnapshot.docs.isEmpty) {
        // Create dummy users
        final dummyUsers = [
          {
            'id': 'admin_001',
            'email': 'admin@gmail.com',
            'password': 'admin123',
            'name': 'Administrator',
            'role': 'UserRole.admin',
          },
          {
            'id': 'guru_001',
            'email': 'guru@gmail.com',
            'password': 'guru123',
            'name': 'Budi Santoso',
            'role': 'UserRole.guru',
          },
          {
            'id': 'siswa_001',
            'email': 'siswa@gmail.com',
            'password': 'siswa123',
            'name': 'Ahmad Fauzi',
            'role': 'UserRole.siswa',
          },
        ];

        // Add users to Firestore
        for (var userData in dummyUsers) {
          await _firestore.collection('users').doc(userData['id'] as String).set(userData);
        }
      }
    } catch (e) {
      print('Error initializing users: $e');
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      // Validate email format
      if (!email.contains('@gmail.com')) {
        throw Exception('Email harus menggunakan @gmail.com');
      }
      
      // Query Firestore for user with matching email and password
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final user = User.fromJson(userData);
        _currentUser = user;
        
        // Save session to Firestore
        await _firestore.collection('sessions').doc('current_session').set({
          'userId': user.id,
          'loginTime': FieldValue.serverTimestamp(),
        });
        
        return user;
      }
      return null;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    try {
      // Get current session
      final sessionDoc = await _firestore.collection('sessions').doc('current_session').get();
      
      if (sessionDoc.exists) {
        final userId = sessionDoc.data()?['userId'];
        if (userId != null) {
          final userDoc = await _firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            _currentUser = User.fromJson(userDoc.data()!);
            return _currentUser;
          }
        }
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      _currentUser = null;
      await _firestore.collection('sessions').doc('current_session').delete();
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
}
