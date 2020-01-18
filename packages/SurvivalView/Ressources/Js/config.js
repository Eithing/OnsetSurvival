function clamp(num, min, max){
    if (num < min) {
        num = min
    }else if (num > max) {
        num = max    
    }
    return num;
}

function Seconds(num){ // Secondes en Ms
    return Math.floor(num * 1000);
}

function Minutes(num){ // Minutes en MS
    return Math.floor(num * 60000);
}

function Hours(num){ // Heures en Ms
    return Math.floor(num * 3,6e+6);
}

function MsToSeconds(num){ // Ms en Secondes
    return Math.floor(num / 1000);
}

function MsToMinutes(num){ // MS en Minutes
    return Math.floor(num / 60000);
}

function MsToHours(num){ // MS en Heures
    return Math.floor(num / 3,6e+6);
}