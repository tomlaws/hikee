class ImageUtils {
  static String imageLink(String link) {
    if (link.startsWith("http")) {
      return link;
    }
    return 'https://hikee.s3.ap-southeast-1.amazonaws.com/${link}';
  }
}
