#include <stdio.h>
#include <string.h>
#include <locale.h>
#include <stdlib.h>

extern void correct(char *a_str, char *b_str);

void Print(char *s) {
    printf("%s", s);
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
    printf("Строки после удаления совпадающих элементов:\n%s\n%s\n", str1, str2);
    printf("Нажмите ENTER для выхода...");
    getchar();
    return 0;
}