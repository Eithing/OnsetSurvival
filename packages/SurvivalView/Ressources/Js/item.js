class Item {
    constructor(itemid, type, imageId, ammout, name, desc="") {
        const {
            spriteColonnes,
            wspace,
            hspace,
            url
        } = CONFIG[type]

        //info sur l'item
        this.element = newEl('div');

        this.element.id = type.toString();

        this.element.classList.add('item');

        this.image = newEl('div');
        this.image.classList.add('item-image')

        this.image.setAttribute("name", name);
        this.image.setAttribute("desc", desc);

        this.image.style.backgroundImage = url;
        this.image.id = imageId;
        let y = Math.floor((imageId - 1) / spriteColonnes) * hspace
        let x = ((imageId - 1) % spriteColonnes) * wspace
        this.image.style.backgroundPosition = "-" + x + "px -" + y + "px";

        this.element.appendChild(this.image);

        this.label = newEl('label');
        if (ammout > 999) {
            ammout = "999+"
        }
        this.itemId = itemid
        this.label.innerHTML = ammout.toString(); //set ammout in label
        this.label.classList.add('item-label')
        this.element.appendChild(this.label);
        return this;
    }
}

const CONFIG = {
    'main': {
        spriteLignes: 2,
        spriteColonnes: 2,
        wspace: 48,
        hspace: 48,
        url: "url('./../../Ressources/images/Admin.jpg')"
    },
    'cloth': {
        spriteLignes: 6,
        spriteColonnes: 5,
        wspace: 50,
        hspace: 50,
        url: "url('./../../Ressources/images/Cloth.jpg')"
    },
    'weapons': {
        spriteLignes: 5,
        spriteColonnes: 4,
        wspace: 50,
        hspace: 50,
        url: "url('./../Ressources/images/Weapons.png')"
    },
    'cars': {
        spriteLignes: 5,
        spriteColonnes: 5,
        wspace: 128,
        hspace: 104,
        url: "url('./../Ressources/images/Cars.jpg')"
    },
    'consommable': {
        spriteLignes: 7,
        spriteColonnes: 5,
        wspace: 40,
        hspace: 40,
        url: "url('./../Ressources/images/consommable.png')"
    },

    'ressource': {
        spriteLignes: 7,
        spriteColonnes: 5,
        wspace: 40,
        hspace: 40,
        url: "url('./../Ressources/images/consommable.png')"
    },
}