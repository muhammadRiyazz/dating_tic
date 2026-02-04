# This prevents R8 from crashing due to the missing Firebase IID classes
-dontwarn com.google.firebase.iid.**
-keep class com.google.firebase.iid.** { *; }

# Also helpful for ML Kit issues
-dontwarn com.google.android.gms.**
-dontwarn com.google.mlkit.**