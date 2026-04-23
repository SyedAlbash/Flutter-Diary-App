# ProGuard rules for optimal size reduction
# Enable aggressive optimization
-optimizationpasses 5
-dontusemixedcaseclassnames

# Flutter specific rules - KEEP as-is
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Play Store core (needed for bundle distribution)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep AndroidX
-keep class androidx.** { *; }
-dontwarn androidx.**

# Keep your app
-keep class com.example.diary_with_lock.** { *; }

# Optimization: Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
