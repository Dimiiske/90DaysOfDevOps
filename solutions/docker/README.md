# Задание по основам и продвинутому использованию Docker

В этом задании вы будете работать с концепциями и инструментами Docker, которым вас научит Shubham Bhaiya. Задание охватывает следующие темы:

- **Введение и цель:** Понимание роли Docker в современной разработке.
- **Виртуализация против контейнеризации:** Изучение различий и преимуществ.
- **Что такое сборка:** Понимание процесса сборки Docker.
- **Терминология Docker:** Ознакомление с ключевыми терминами Docker.
- **Компоненты Docker:** Изучение Docker Engine, образов, контейнеров и многого другого.
- **Создание проекта с использованием Docker:** Контейнеризация примера проекта.
- **Многоэтапная сборка Docker / Образы без дистрибутива:** Оптимизация образов.
- **Docker Hub (Push/Tag/Pull):** Управление и распространение образов Docker.
- **Тома Docker:** Сохранение данных между запусками контейнеров.
- **Сетевое взаимодействие Docker:** Подключение контейнеров с помощью сетей.
- **Docker Compose:** Оркестрация многоконтейнерных приложений.
- **Docker Scout:** Анализируйте ваши образы на наличие уязвимостей и полезной информации.

Выполните все приведенные ниже задания и задокументируйте свои действия, команды и наблюдения в файле с именем `solution.md`.

---

## Challenge Tasks

### Задача 1: Введение и концептуальное понимание
1. **Написать введение:**  
   - В файле `solution.md` кратко объясните назначение Docker в современном DevOps.
   - Сравните **виртуализацию и контейнеризацию** и объясните, почему контейнеризация является предпочтительным подходом для микросервисов и конвейеров CI/CD.

---

### Задача 2: Создайте Dockerfile для тестового проекта.
1. **Выберите или создайте пример приложения.:**  
   - Выберите простое приложение (например, базовое приложение на Node.js, Python или Java, которое выводит «Hello, Docker!» или отображает простую веб-страницу).

   app.py:

   ```
   from flask import Flask

   app = Flask(__name__)

   @app.route('/')
   def hello_world():
   return 'Hello World!'

   if __name__ == '__main__':
      app.run(host='0.0.0.0', port=8080)
   
   ```

2. **Напишите Dockerfile:**  
   - Создайте файл Dockerfile, определяющий способ сборки образа для вашего приложения.

   Dockerfile:

   ```
   FROM python:3.11.14-alpine3.23

   RUN pip install flask

   COPY app.py .

   CMD ["python3", "flask.py"]
   ```
   
   - Добавьте в свой Dockerfile комментарии, поясняющие каждую инструкцию.
      FROM - базовый образ
      RUN - устанавливаем flask библиотеку
      COPY - копируем файл с кодом
      CMD - запускаем 

   - Создайте свой образ, используя:
     ```bash
     docker build -t <your-username>/sample-app:latest .
     ```

   <img src="img/1.png" width="700"/>

3. **Проверьте свою сборку:**  
   - Запустите контейнер локально, чтобы убедиться, что он работает должным образом:
     ```bash
     docker run -d -p 8080:80 <your-username>/sample-app:latest
     ```
   - Убедитесь, что контейнер запущен, с помощью:
     ```bash
     docker ps
     ```
   - Проверьте логи с помощью:
     ```bash
     docker logs <container_id>
     ```

   <img src="img/2.png" width="700"/>

---

### Задача 3: Изучите терминологию и компоненты Docker.
1. **Ключевые термины документа:**  
   - В файле `solution.md` перечислите и кратко опишите ключевые термины Docker, такие как образ, контейнер, Dockerfile, том и сеть.
   - Объясните основные компоненты Docker (Docker Engine, Docker Hub и т. д.) и как они взаимодействуют.

---

### Задача 4: Оптимизируйте свой образ Docker с помощью многоэтапной сборки.
1. **Реализуйте многоэтапную сборку Docker.:**  
   - Измените существующий файл `Dockerfile`, чтобы включить многоэтапную сборку. 
   - Цель состоит в том, чтобы получить лёгкое, **без лишних элементов** (или минималистичное) итоговое изображение.

   ```
   FROM python:3.11.14-alpine3.23 AS base

   WORKDIR /app

   FROM base AS installer 

   RUN pip install flask

   FROM installer AS app

   COPY app.py .

   CMD ["python3", "/app/app.py"]
   ```
2. **Сравните размеры изображений:**  
   - Создайте образ до и после многоэтапной модификации сборки и сравните их размеры, используя:
     ```bash
     docker images
     ```
3. **Задокументируйте различия:**  
   - В файле `solution.md` объясните преимущества многоэтапной сборки и ее влияние на размер образа.

---

### Задача 5: Управляйте своими образами с помощью Docker Hub.
1. **Затегируйте свой образ:**  
   - Добавьте к изображению соответствующие теги.:
     ```bash
     docker tag <your-username>/sample-app:latest <your-username>/sample-app:v1.0
     ```

     <img src="img/4.png" width="700"/>

2. **Загрузите свой образ в Docker Hub.:**  
   - При необходимости войдите в Docker Hub.:
     ```bash
     docker login
     ```

      <img src="img/3.png" width="700"/>

   - Запушьте образ:
     ```bash
     docker push <your-username>/sample-app:v1.0
     ```

     <img src="img/5.png" width="700"/>

3. **(Optional) Скачайте образ:**  
   - Verify by pulling your image:
     ```bash
     docker pull <your-username>/sample-app:v1.0
     ```

      <img src="img/6.png" width="700"/>

---

### Задача 6: Сохранение данных с помощью томов Docker
1. **Создайте том Docker.:**  
   - Создайте том Docker.:
     ```bash
     docker volume create my_volume
     ```

   <img src="img/7.png" width="700"/>

2. **Запустите контейнер с использованием тома.:**  
   - Запустите контейнер, используя том для сохранения данных.:
     ```bash
     docker run -d -v my_volume:/app/data <your-username>/sample-app:v1.0
     ```

   <img src="img/8.png" width="700"/>

3. **Документируйте процесс:**  
   - В файле `solution.md` объясните, как тома Docker помогают обеспечить сохранение данных и почему они полезны.

---

### Задача 7: Настройка сети Docker
1. **Создание собственной сети Docker:**  
   - Создание собственной сети Docker:
     ```bash
     docker network create my_network
     ```

2. **Запуск контейнеров в одной сети.:**  
   - Запустите два контейнера (например, ваше тестовое приложение и простую базу данных, такую ​​как MySQL) в одной сети, чтобы продемонстрировать взаимодействие между контейнерами:
     ```bash
     docker run -d --name sample-app --network my_network <your-username>/sample-app:v1.0
     docker run -d --name my-db --network my_network -e MYSQL_ROOT_PASSWORD=root mysql:latest
     ```

   <img src="img/9.png" width="700"/>

   <img src="img/10.png" width="700"/>

   <img src="img/11.png" width="700"/>

3. **Документируйте процесс:**  
   - В файле `solution.md` опишите, как сетевые возможности Docker обеспечивают взаимодействие между контейнерами и каково их значение в многоконтейнерных приложениях.

---

### Задача 8: Организуйте работу с помощью Docker Compose.
1. **Создайте docker-compose.yml File:**  
   - Создайте файл `docker-compose.yml`, в котором определены как минимум две службы (например, ваше тестовое приложение и база данных).
   - Включите определения для услуг, сетей и вольюмов.
2. **Разверните ваше приложение:**  
   - Запустите приложение, используя:
     ```bash
     docker-compose up -d
     ```

   <img src="img/11.png" width="700"/>


   - Проверьте работу системы, затем выключите её с помощью:
     ```bash
     docker-compose down
     ```

   <img src="img/12.png" width="700"/>


3. **Документируйте процесс:**  
   - Подробно опишите каждую службу и конфигурацию в вашем файле `solution.md`.

---

### Task 9: Analyze Your Image with Docker Scout
1. **Run Docker Scout Analysis:**  
   - Execute Docker Scout on your image to generate a detailed report of vulnerabilities and insights:
     ```bash
     docker scout cves <your-username>/sample-app:v1.0
     ```
   - Alternatively, if available, run:
     ```bash
     docker scout quickview <your-username>/sample-app:v1.0
     ```
     to get a summarized view of the image’s security posture.
   - **Optional:** Save the output to a file for further analysis:
     ```bash
     docker scout cves <your-username>/sample-app:v1.0 > scout_report.txt
     ```

2. **Review and Interpret the Report:**  
   - Carefully review the output and focus on:
     - **List of CVEs:** Identify vulnerabilities along with their severity ratings (e.g., Critical, High, Medium, Low).
     - **Affected Layers/Dependencies:** Determine which image layers or dependencies are responsible for the vulnerabilities.
     - **Suggested Remediations:** Note any recommended fixes or mitigation strategies provided by Docker Scout.
   - **Comparison Step:** If possible, compare this report with previous builds to assess improvements or regressions in your image's security posture.
   - If Docker Scout is not available in your environment, document that fact and consider using an alternative vulnerability scanner (e.g., Trivy, Clair) for a comparative analysis.

3. **Document Your Findings:**  
   - In your `solution.md`, provide a detailed summary of your analysis:
     - List the identified vulnerabilities along with their severity levels.
     - Specify which layers or dependencies contributed to these vulnerabilities.
     - Outline any actionable recommendations or remediation steps.
     - Reflect on how these insights might influence your image optimization or overall security strategy.
   - **Optional:** Include screenshots or attach the saved report file (`scout_report.txt`) as evidence of your analysis.

---

### Task 10: Documentation and Critical Reflection
1. **Update `solution.md`:**  
   - List all the commands and steps you executed.
   - Provide explanations for each task and detail any improvements made (e.g., image optimization with multi-stage builds).
2. **Reflect on Docker’s Impact:**  
   - Write a brief reflection on the importance of Docker in modern software development, discussing its benefits and potential challenges.

---

## Additional Resources

- **[Docker Documentation](https://docs.docker.com/)**  
- **[Docker Hub](https://docs.docker.com/docker-hub/)**  
- **[Multi-stage Builds](https://docs.docker.com/develop/develop-images/multistage-build/)**  
- **[Docker Compose](https://docs.docker.com/compose/)**  
- **[Docker Scan (Vulnerability Scanning)](https://docs.docker.com/engine/scan/)**  
- **[Containerization vs. Virtualization](https://www.docker.com/resources/what-container)**
