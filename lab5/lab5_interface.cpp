#include <stdio.h>
#include <string.h>
#include <locale.h>
#include <stdlib.h>

extern void correct(char *a_str, char *b_str);

void Print(char *s) {
    printf("%s", s);
}

void Swap(char *a_str, char *b_str) {
    int min_len = strlen(a_str) > strlen(b_str) ? strlen(b_str) : strlen(b_str);
    for (int i = 0; i < min_len; i++) {
        if (a_str[i]==b_str[i]) {
            a_str[i] = ' ';
            b_str[i] = ' ';
        }
    }
    
    printf("Строки после удаления совпадающих элементов:\n%s\n%s\n", a_str, b_str);
    printf("Нажмите ENTER для выхода...");
    getchar();
}

int main() {
    setlocale(LC_ALL, "Russian");
    char str1[126] = "";
    char str2[126] = "";
    printf("Введите первую строку (до 125 символов):\n");
    fgets(str1, sizeof(str1), stdin);
    printf("Введите вторую строку (до 125 символов):\n");
    fgets(str2, sizeof(str2), stdin);
    correct(str1, str2);
    return 0;
}