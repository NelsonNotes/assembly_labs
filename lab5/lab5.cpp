#include "stdafx.h"
#include <stdio.h>
#include <conio.h>
#include <string.h>
#include <locale.h>
#include <stdlib.h>
extern "C" void __cdecl correct(char *str,int n, char *res);
extern "C" void Print(char *s) {
    printf("%s", s);
}
int main() {
    setlocale(LC_ALL, "Russian");
    char str[256];
    char res[256] = "";
    printf("Введите строку не более 255 символов\n");
    fgets(str, sizeof(str), stdin);
    printf("Введённая строка:\n%s", str);
    correct(str,strlen(str)+1,res);
    printf("Скорректированная строка:\n%s", res);
    printf("Введите любой символ для выхода");
    getchar();
    return 0;
}