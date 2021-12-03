FROM python:3.10-slim-buster AS base_python_slim
FROM python:3.10-buster AS base_python_full

# # ---- Create Base Python Package Installer ---- #
# FROM python_base as python_package_installer
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     bash \
#     bzip2 \
#     default-libmysqlclient-dev \
#     gcc \
#     git \
#     libc-ares2 \
#     make \
#     openssl \
#     patch equivs
# RUN pip install --upgrade pip


# -------- Django Project Build Targets ---- #

# ---- Django Project Requirements Updater ---- #
FROM base_python_full as django_project_update_requirements
RUN pip install pip-tools
COPY ./django_project/requirements.src /tmp/django_project/requirements.src
RUN pip-compile --generate-hashes \
    --output-file=/tmp/django_project/requirements.txt \
    /tmp/django_project/requirements.src

# ---- Django Project Package Installer ---- #
FROM base_python_full as django_project_packages
COPY ./django_project/requirements.txt /tmp/django_project/requirements.txt
# After this next step: lib, bin and other top-level folders 
# will be in /tmp/django_project/python_env
RUN pip install --require-hashes \
    --prefix /tmp/django_project/python_env \
    -r /tmp/django_project/requirements.txt

# ---- Django Project Application ---- #
FROM base_python_slim as django_project
# Copy the app's packages (lib and bin)
COPY --from=django_project_packages /tmp/django_project/python_env /usr/local
COPY ./django_project /django_project
WORKDIR /django_project
# TODO - Run using a runner: either gunicorn or uvicorn
# CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
CMD [ "python", "manage.py", "runserver", "0.0.0.0:8000" ]


# -------- API Testing Targets -------- #

# ---- api_tests Requirements Updater ---- #
FROM base_python_full as api_tests_update_requirements
RUN pip install pip-tools
COPY ./api_tests/requirements.src /tmp/api_tests/requirements.src
RUN pip-compile --generate-hashes \
    --output-file=/tmp/api_tests/requirements.txt \
    /tmp/api_tests/requirements.src

# ---- api_tests Package Installer ---- #
FROM base_python_full as api_tests_packages
COPY ./api_tests/requirements.txt /tmp/api_tests/requirements.txt
# After this next step: lib, bin and other top-level folders 
# will be in /tmp/app/python_env
RUN pip install --require-hashes \
    --prefix /tmp/api_tests/python_env \
    -r /tmp/api_tests/requirements.txt

# ---- api_tests Test Runner ---- #
FROM base_python_slim as api_tests
COPY --from=api_tests_packages /tmp/api_tests/python_env /usr/local
COPY ./django_project /django_project
COPY ./api_tests /api_tests
WORKDIR /api_tests
CMD ["./run_tests.sh"]


# -------- E2E Testing Targets -------- #

# ---- e2e_tests Requirements Updater ---- #
FROM base_python_full as e2e_tests_update_requirements
RUN pip install pip-tools
COPY ./e2e_tests/requirements.src /tmp/e2e_tests/requirements.src
RUN pip-compile --generate-hashes \
    --output-file=/tmp/e2e_tests/requirements.txt \
    /tmp/e2e_tests/requirements.src

# ---- e2e_tests Package Installer ---- #
FROM base_python_full as e2e_tests_packages
COPY ./e2e_tests/requirements.txt /tmp/e2e_tests/requirements.txt
# After this next step: lib, bin and other top-level folders 
# will be in /tmp/app/python_env
RUN pip install --require-hashes \
    --prefix /tmp/e2e_tests/python_env \
    -r /tmp/e2e_tests/requirements.txt

# ---- e2e_tests Test Runner ---- #
FROM base_python_slim as e2e_tests
COPY --from=e2e_tests_packages /tmp/e2e_tests/python_env /usr/local
COPY ./django_project /django_project
COPY ./e2e_tests /e2e_tests
WORKDIR /e2e_tests
CMD ["./run_tests.sh"]


# -------- UNIT Testing Targets -------- #

# ---- unit_tests Requirements Updater ---- #
FROM python_package_installer as unit_tests_update_requirements
RUN pip install pip-tools
COPY ./unit_tests/requirements.src /tmp/unit_tests/requirements.src
RUN pip-compile --generate-hashes \
    --output-file=/tmp/unit_tests/requirements.txt \
    /tmp/unit_tests/requirements.src

# ---- unit_tests Package Installer ---- #
FROM python_package_installer as unit_tests_packages
COPY ./unit_tests/requirements.txt /tmp/unit_tests/requirements.txt
# After this next step: lib, bin and other top-level folders 
# will be in /tmp/app/python_env
RUN pip install --require-hashes \
    --prefix /tmp/unit_tests/python_env \
    -r /tmp/unit_tests/requirements.txt

# ---- unit_tests Test Runner ---- #
FROM base_python_slim as unit_tests
COPY --from=unit_tests_packages /tmp/unit_tests/python_env /usr/local
COPY ./django_project /django_project
COPY ./unit_tests /unit_tests
WORKDIR /unit_tests
CMD ["./run_tests.sh"]
