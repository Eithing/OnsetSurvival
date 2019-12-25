class Item {
    constructor(type, imageId) {
        //info sur l'item
        this.element = newEl('div');
        this.element.id = type.toString();

        this.element.classList.add('item');

        this.image = newEl('img');
        this.image.classList.add('item-image')
        this.image.src = "./../../Ressources/" + type + "/" + imageId + ".jpg"
        this.element.appendChild(this.image);
        return this;
    }
}