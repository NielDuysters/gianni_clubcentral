// HELPER FUNCTIONS

import 'dart:io';

// Function to clear console
void clear_screen() {
    if (Platform.isWindows) {
        Process.run('cls', [], runInShell: true);
    } else {
        stdout.write('\x1B[2J\x1B[0;0H');
    }
}

// Function to launch a URL in the browser
void open_in_browser(String url) {
    if (Platform.isWindows) {
        Process.run('start', [url]);
    } else if (Platform.isLinux) {
        Process.run('xdg-open', [url]);
    } else if (Platform.isMacOS) {
        Process.run('open', [url]);
    } else {
        print('Unsupported platform');
    }
}
