#!/bin/sh
clear
CURRENT_FOLDER="" #Example : "/Users/asus/Development/mobile"
PROJECT_FOLDER="" #Example : "example-project-mobile"
JDK_FOLDER= "" #Example : "/Library/Java/JavaVirtualMachines/jdk1.8.0_102.jdk/Contents/Home/bin/"
ZIPALIGN_FOLDER= "" #Example : "/usr/local/Cellar/android-sdk/24.4.1_1/build-tools/25.0.0"
KEY_STORE= "" #Example : "/Users/asus/Development/IOS/sequis-mobile/platforms/android/android-my-release-key.keystore"
STAGGING_APK= CURRENT_FOLDER."/".PROJECT_FOLDER."/platforms/android/build/outputs/apk/android-debug.apk" #Example : CURRENT_FOLDER."/".PROJECT_FOLDER."/platforms/android/build/outputs/apk/android-debug.apk"
UNSIGNED_APK= CURRENT_FOLDER."/".PROJECT_FOLDER."/platforms/android/build/outputs/apk/android-release-unsigned.apk" #Example : CURRENT_FOLDER."/".PROJECT_FOLDER."/platforms/android/build/outputs/apk/android-release-unsigned.apk"
SIGNED_APK= CURRENT_FOLDER."/".PROJECT_FOLDER."/platforms/android/build/outputs/apk/android-release-signed.apk" #Example : CURRENT_FOLDER."/".PROJECT_FOLDER."/platforms/android/build/outputs/apk/android-release-signed.apk"

echo "ANDROID BUILDER APK"

if [ -d "$PROJECT_FOLDER" ]; then
    cd $PROJECT_FOLDER
    pwd
    echo "1. Stagging"
    echo "2. Adhoc-Production"
    echo "3. Release"
    echo "4. Exit"
    echo "Choose what do you want ? "
    read MAIN_MENU

    if [ "$MAIN_MENU" = "1" ] ; then
        clear
        echo "ANDROID BUILDER APK FOR STAGGING"
        ionic build android
        RESULT="$STAGGING_APK"
    fi

    if [ "$MAIN_MENU" = "2" ] ; then
        clear
        echo "ANDROID BUILDER APK FOR ADHOC-PRODUCTION"
        ionic build android
        RESULT="$STAGGING_APK"
    fi

    if [ "$MAIN_MENU" = "3" ] ; then
        clear
        echo "ANDROID BUILDER APK FOR RELEASE"
        ionic build android --release
        cd $JDK_FOLDER
        jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore "$KEY_STORE" "$UNSIGNED_APK" ""
        cd $ZIPALIGN_FOLDER
        ./zipalign -v 4 "$UNSIGNED_APK" "$SIGNED_APK"
        RESULT="$SIGNED_APK"
    fi

    if [ "$MAIN_MENU" = "4" ] ; then
        clear
        echo "BYE!!"
    fi

    if [ "$MAIN_MENU" != "4" ] ; then
        echo "What current version?"
        read VERSION
        if [ "$MAIN_MENU" = "1" ]; then
            mv "$RESULT" "$CURRENT_FOLDER/$VERSION-stagging.apk"
        elif [ "$MAIN_MENU" = "2" ]; then
            mv "$RESULT" "$CURRENT_FOLDER/$VERSION-adhoc-production.apk"
        elif [ "$MAIN_MENU" = "3" ]; then
            mv "$RESULT" "$CURRENT_FOLDER/$VERSION-store.apk"
        fi
        echo "COMPLETE!"
    fi
else
    echo "Make sure your project sequis mobile is '$PROJECT_FOLDER' or change settings PROJECT_FOLDER "
fi
