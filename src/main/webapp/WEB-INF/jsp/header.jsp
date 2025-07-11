<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>The One Piece Shop</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="styles/style.css">
    <script src="scripts/main.js" defer></script>
</head>
<body>
<header class="navbar navbar-expand-lg navbar-dark bg-dark px-3">
    <a class="navbar-brand" href="index.jsp">
        <strong>The One Piece Shop</strong>
    </a>
    <nav class="collapse navbar-collapse">
        <ul class="navbar-nav ms-auto">
            <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
            <li class="nav-item"><a class="nav-link" href="ProductServlet">Catalogo</a></li>
            <li class="nav-item"><a class="nav-link" href="CartServlet">Carrello</a></li>
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <li class="nav-item"><a class="nav-link" href="profile.jsp">Profilo</a></li>
                    <li class="nav-item"><a class="nav-link" href="LogoutServlet">Logout</a></li>
                </c:when>
                <c:otherwise>
                    <li class="nav-item"><a class="nav-link" href="LoginServlet">Login</a></li>
                    <li class="nav-item"><a class="nav-link" href="register.jsp">Registrati</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>
</header>
<main class="container-fluid" role="main">