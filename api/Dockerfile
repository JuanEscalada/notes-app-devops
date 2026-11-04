FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Instalar dependencias
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Crear usuario sin privilegios
RUN groupadd --system notes && \
    useradd --system --gid notes notes

# Copiar código de la aplicación
COPY --chown=notes:notes notes/ ./notes/
COPY --chown=notes:notes run.py ./

# Ejecutar como usuario no privilegiado
USER notes

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "--access-logfile", "-", "--error-logfile", "-", "run:app"]